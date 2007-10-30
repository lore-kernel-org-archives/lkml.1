Return-Path: <linux-kernel-owner+w=401wt.eu-S1754701AbXJ3IkI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754701AbXJ3IkI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 04:40:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751955AbXJ3Ijz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 04:39:55 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:17680 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751551AbXJ3Ijy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 04:39:54 -0400
In-Reply-To: <1193610737.9637.1.camel@concordia>
References: <200710261437.29117.ossthema@de.ibm.com> <1193610737.9637.1.camel@concordia>
Subject: Re: [PATCH] ehea: add kexec support
To: michael@ellerman.id.au
Cc: Jan-Bernd Themann <THEMANN@de.ibm.com>, Jeff Garzik <jeff@garzik.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ppc <linuxppc-dev@ozlabs.org>, Marcus Eder <MEDER@de.ibm.com>,
       netdev <netdev@vger.kernel.org>, ossthema@linux.vnet.ibm.com,
       Stefan Roscher <stefan.roscher@de.ibm.com>,
       Thomas Q Klein <TKLEIN@de.ibm.com>
X-Mailer: Lotus Notes Release 8.0 August 02, 2007
Message-ID: <OF79E7ACE7.5D0488CE-ONC1257384.002E58C0-C1257384.002F8561@de.ibm.com>
From: Christoph Raisch <RAISCH@de.ibm.com>
Date: Tue, 30 Oct 2007 09:39:49 +0100
X-MIMETrack: Serialize by Router on D12ML067/12/M/IBM(Release 7.0.2HF71 | November 3, 2006) at
 30/10/2007 09:39:51
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Michael Ellerman <michael@ellerman.id.au> wrote on 28.10.2007 23:32:17:
>
>
> How do you plan to support kdump?
>

When kexec is fully supported kdump should work out of the box
as for any other ethernet card (if you load the right eth driver).
There's nothing specific to kdump you have to handle in
ethernet device drivers.
Hope I didn't miss anything here...

Gruss / Regards
Christoph R

