Return-Path: <linux-kernel-owner+w=401wt.eu-S1764035AbXESUWx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764035AbXESUWx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 16:22:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760191AbXESUWp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 16:22:45 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:64646 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759714AbXESUWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 16:22:44 -0400
Message-ID: <464F5C8F.5000304@cv-sv.de>
Date: Sat, 19 May 2007 22:22:39 +0200
From: Christian Volkmann <haveaniceday@cv-sv.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; de-AT; rv:1.8.1.2) Gecko/20070218 SUSE/1.1.1-5.1 SeaMonkey/1.1.1
MIME-Version: 1.0
CC: Claas Langbehn <claas@rootdir.de>, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>
Subject: Via C3: other flags possible ?
References: <464B9D2C.7040704@cv-sv.de> <20070517004209.GE16810@redhat.com> <200705190753.16570.ak@suse.de> <464EE2AA.3030607@cv-sv.de> <464F332C.8060904@rootdir.de>
In-Reply-To: <464F332C.8060904@rootdir.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1/wDf1X0O5tGXJdJaol6zfVuGg8e/vWkNljdfE
 Z2pqgvuGlYdnKxMCmhPvhHromerE0KupsntoxNlP1WBiDn/QN9
 L5rE9ge/h2q+XVYdBM3Lw==
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Claas asked for the NX flag for the Via C3 (?) processors
in another thread.

I do not know another synonym for this?

Claas Langbehn wrote:
> Hello Christian,
>
> do you know if and how it's possible to enable NX_bit too?
>
>
> Claas
>


The via C3 documentation is at:
http://www.via.com.tw/en/products/processors/c3/

I have seen in c3_ebga.zip that the processor might support
3DNow. But you have to check the registers about this.

Inside linux-2.6.22-rc1/arch/i386/kernel/cpu/centaur.c I just
see a "fixed type" detection.

Does anybody have more information on this ?
Otherwise I would play around a little with my C3 Nehemiah
and try to change the detection according the Via documentation.

Best regards,

Christian


PS @Andi, did you look for the page above for data sheets?
  Please see the download section.
