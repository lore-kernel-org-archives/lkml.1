Return-Path: <linux-kernel-owner+w=401wt.eu-S1752446AbZKPOzq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752446AbZKPOzq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 09:55:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752087AbZKPOzo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 09:55:44 -0500
Received: from mail.digidescorp.com ([66.244.163.200]:47244 "EHLO
	digidescorp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751986AbZKPOzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 09:55:42 -0500
X-Spam-Processed: digidescorp.com, Mon, 16 Nov 2009 08:47:34 -0600
X-Authenticated-Sender: steve@digidescorp.com
X-Return-Path: prvs=1571e16926=steve@digidescorp.com
X-Envelope-From: steve@digidescorp.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] procfs: Use proper units for noMMU statm
From: "Steven J. Magnani" <steve@digidescorp.com>
Reply-To: steve@digidescorp.com
To: =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20091114044153.GB2416@hack>
References: <1258163534-3617-1-git-send-email-steve@digidescorp.com>
	 <20091114044153.GB2416@hack>
Content-Type: text/plain; charset="UTF-8"
Organization: Digital Design Corporation
Date: Mon, 16 Nov 2009 08:47:33 -0600
Message-Id: <1258382853.3019.0.camel@iscandar.digidescorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-11-14 at 12:41 +0800, Américo Wang wrote:
> On Fri, Nov 13, 2009 at 07:52:14PM -0600, steve@digidescorp.com wrote:
> >On no-MMU systems, sizes reported in /proc/n/statm have units of bytes. 
> >Per Documentation/filesystems/proc.txt, these values should be in pages.
> >
> > ...
> >
> >+	*data = (mm->start_stack - mm->start_data) >> PAGE_SHIFT;
> 
> Are '->start_stack' and '->start_data' already page aligned on NOMMU arch?
> 

In looking over binfmt_flat.c (main executable type for noMMU systems),
I don't think there's a guarantee of more than 32- or 64-bit alignment.
Thanks for the suggestion, I'll submit an updated patch.

------------------------------------------------------------------------
 Steven J. Magnani               "I claim this network for MARS!
 www.digidescorp.com              Earthling, return my space modulator!"

 #include <standard.disclaimer>



