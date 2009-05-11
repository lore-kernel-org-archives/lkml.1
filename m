Return-Path: <linux-kernel-owner+w=401wt.eu-S1752916AbZEKHY6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752916AbZEKHY6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 03:24:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751991AbZEKHYq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 03:24:46 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:43474 "EHLO
	pophost.sonytel.be" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751611AbZEKHYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 03:24:45 -0400
Date: Mon, 11 May 2009 09:24:44 +0200 (CEST)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Christoph Hellwig <hch@lst.de>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-fbdev-devel@lists.sourceforge.net, Arnd Bergmann <arnd@arndb.de>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       cbe-oss-dev@ozlabs.org
Subject: Re: [PATCH 08/15] powerpc/cell: Extract duplicated IOPTE_* to
 <asm/iommu.h>
In-Reply-To: <20090510190825.GB23659@lst.de>
Message-ID: <alpine.LRH.2.00.0905110923480.14263@vixen.sonytel.be>
References: <1241791284-11490-1-git-send-email-Geert.Uytterhoeven@sonycom.com> <1241791284-11490-2-git-send-email-Geert.Uytterhoeven@sonycom.com> <1241791284-11490-3-git-send-email-Geert.Uytterhoeven@sonycom.com> <1241791284-11490-4-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1241791284-11490-5-git-send-email-Geert.Uytterhoeven@sonycom.com> <1241791284-11490-6-git-send-email-Geert.Uytterhoeven@sonycom.com> <1241791284-11490-7-git-send-email-Geert.Uytterhoeven@sonycom.com> <1241791284-11490-8-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1241791284-11490-9-git-send-email-Geert.Uytterhoeven@sonycom.com> <20090510190825.GB23659@lst.de>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 May 2009, Christoph Hellwig wrote:
> On Fri, May 08, 2009 at 04:01:17PM +0200, Geert Uytterhoeven wrote:
> > +/* Cell page table entries */
> > +#define IOPTE_PP_W		0x8000000000000000ul /* protection: write */
> > +#define IOPTE_PP_R		0x4000000000000000ul /* protection: read */
> > +#define IOPTE_M			0x2000000000000000ul /* coherency required */
> > +#define IOPTE_SO_R		0x1000000000000000ul /* ordering: writes */
> > +#define IOPTE_SO_RW             0x1800000000000000ul /* ordering: r & w */
> > +#define IOPTE_RPN_Mask		0x07fffffffffff000ul /* RPN */
> > +#define IOPTE_H			0x0000000000000800ul /* cache hint */
> > +#define IOPTE_IOID_Mask		0x00000000000007fful /* ioid */
> 
> If this is in a global header it should probably have a CELL_ prefix.

Fair enough; I'll use CBE_, as that's shorter and used for the other
definitions in arch/powerpc/include/asm/cell-*.h, too.

With kind regards,

Geert Uytterhoeven
Software Architect
Techsoft Centre

Technology and Software Centre Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 · RPR Brussels
Fortis · BIC GEBABEBB · IBAN BE41293037680010
