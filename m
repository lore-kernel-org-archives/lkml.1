Return-Path: <linux-kernel-owner+w=401wt.eu-S1754130AbYJFQbk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130AbYJFQbk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 12:31:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752802AbYJFQbd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 12:31:33 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:8425 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503AbYJFQbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 12:31:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:date:user-agent:cc:references:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :message-id:from;
        b=lufqHDg9Jeoqu/UOS8XOYDAYgryg/sUPmyh7qdqxu9gX3CWR1SMK0x/xUSrhkjqRAD
         kkke3KTsam5ziYP1XSCaAZnZI0urIYL2dQPPrjgW0m7/6qye4wFCNQ9NcLEl8wd/tcal
         z4Lv4NaLiJiKV5Y3qZKG10yNIMukLXSPDvUU0=
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: Re: [PATCH v3] rfkill-input doesn't work until 5 minutes after boot
Date: Mon, 6 Oct 2008 18:31:23 +0200
User-Agent: KMail/1.9.9
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>, hmh@hmh.eng.br,
       linux-kernel@vger.kernel.org
References: <20081004204342.GA29620@srcf.ucam.org> <20081005213330.GA11355@srcf.ucam.org> <48E9A780.9090406@yahoo.com>
In-Reply-To: <48E9A780.9090406@yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810061831.23542.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 06 October 2008, Sitsofe Wheeler wrote:
> Matthew Garrett wrote:
> > On Sun, Oct 05, 2008 at 05:24:39PM -0400, Dmitry Torokhov wrote:
> > 
> >> I'd rather have something like below. It should probably go through
> >> David's (networking) tree. since it is in net/.
> > 
> > Fine with me, as long as Sitsofe can confirm it works?
> 
> Dmitry's patch also works for me.
> 
> Tested-by: Sitsofe Wheeler <sitsofe@yahoo.com>

Dmitry's patch has my personal preference, because it
decreases the change of forgetting the initialization.

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
