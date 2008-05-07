Return-Path: <linux-kernel-owner+w=401wt.eu-S1759021AbYEGQqo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759021AbYEGQqo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 12:46:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751517AbYEGQqa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 12:46:30 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:12571 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183AbYEGQq2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 12:46:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=XPJ7Y57GZ0+WbkPtXGgBMcZbdtx9yHWlcWeaCGVDu7Pf1t8dEbk0osK9K1qPL9/iRydUUFJ3+EMPdA/IWgm3YDphJiwoel2z5+vdM16an1lje/9OCkKCp+DTnVH/0WtSv4NaDSW0DTvBdFoVa+wBYzcqlny9VLT55J6zQOlN1eE=
Message-ID: <e2e108260805070946t63f35e36q6960bdff11fecd8c@mail.gmail.com>
Date: Wed, 7 May 2008 18:46:25 +0200
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: "=?ISO-8859-1?Q?St=E9phane_ANCELOT?=" <sancelot@free.fr>
Subject: Re: Compact Flash Question
Cc: "Helge Hafting" <helge.hafting@aitel.hist.no>,
       "Tomasz Chmielewski" <mangoo@wpkg.org>,
       LKML <linux-kernel@vger.kernel.org>, YSadgat1@gcte.com,
       linux-os@analogic.com, Alan <alan@lxorguk.ukuu.org.uk>,
       "Linux IDE" <linux-ide@vger.kernel.org>,
       "Jeff Woods" <jeff@jeffwoods.us>
In-Reply-To: <4821C462.2000108@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <48215673.3060201@wpkg.org>
	 <e2e108260805070044v42f596bbj39c5b52b6f0a096@mail.gmail.com>
	 <48216039.3070001@wpkg.org> <4821A12F.2020800@aitel.hist.no>
	 <4821C462.2000108@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 7, 2008 at 5:01 PM, Stéphane ANCELOT <sancelot@free.fr> wrote:
>
> we use  silicon systems CF  with wear leveling inside  , we write a few
> kb data back each 1/4 h  on it.(log /tmp files  are redirected to ram)

Silicon Systems CompactFlashes are the among the most reliable
CompactFlashes I have used in embedded devices. See also
http://www.siliconsystems.com/silicondrive/whitepapers/SSWP03-Endurance-R.pdf
for a whitepaper that explains their wear leveling and error
correction algorithms. Furthermore, Silicon Systems has a technology
called SiSMART that allows to monitor by how far the CompactFlash is
worn out, such that it can be monitored whether or not it is time to
replace the CompactFlash. (Note: I am not affiliated in any way to
Silicon Systems.)

Bart.
