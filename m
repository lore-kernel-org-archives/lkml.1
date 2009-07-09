Return-Path: <linux-kernel-owner+w=401wt.eu-S1751615AbZGIXbs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751615AbZGIXbs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 19:31:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751146AbZGIXbj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 19:31:39 -0400
Received: from an-out-0708.google.com ([209.85.132.246]:48526 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100AbZGIXbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 19:31:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=mbpofqj/aexFnGJUPXxaZV9EhUMK50s9H4iqUnbULRUmmRfesaoQJ+DPZrj++dtrfv
         U4DTZCS2ZfdScLu3wdcwnQa0Li+zvnyR37CaQRQb9S80KCOWb4Ey8J7BmOUx75nx4Rkk
         JLuxZdee1YIcRWCdv53WHMcWxtpGt40sZx5sQ=
MIME-Version: 1.0
In-Reply-To: <4A56344C.3010500@warlich.name>
References: <4A4771FD.1020207@warlich.name> <4A52F39A.1030704@warlich.name>
	 <4A5311C7.1020507@warlich.name> <4A535973.9090206@gmail.com>
	 <4A5388EA.7030503@warlich.name> <4A53DA88.5080703@gmail.com>
	 <4A543FA5.1090608@warlich.name> <4A54AD1A.1040009@kernel.org>
	 <4A54B98B.50806@gmail.com> <4A56344C.3010500@warlich.name>
Date: Thu, 9 Jul 2009 17:31:36 -0600
Message-ID: <51f3faa70907091631s329255en5fc197091b9ae4f0@mail.gmail.com>
Subject: Re: "EXT3-fs error" after resume from s2ram
From: Robert Hancock <hancockrwd@gmail.com>
To: Christof Warlich <christof@warlich.name>
Cc: Tejun Heo <htejun@gmail.com>, linux-kernel@vger.kernel.org,
       ide <linux-ide@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 9, 2009 at 12:17 PM, Christof Warlich<christof@warlich.name> wrote:
> Hi Tejun, Robert,
>
> hey, great: Suspend to ram seems to work like a charm now! Many thanks to
> Robert for taking the time to identify the root cause and to Tejun for
> providing the patch.
>
> I've attached both boot and suspend / resume messages from
> /var/log/kern.log, just let me know if I can do anything else to
> help getting the patch into an official kernel release. Furthermore, I would
> be happy to be kept posted on the progress being made regarding this.
>
> Just one clarification: From what I understood so far, it will be impossible
> to ever utilize the full disk capacity as long as the BIOS applies the HPA
> on boot, right?

I believe that's the case, yes.. if the BIOS is applying the HPA on
each boot, then we can't change the max address again without a
hardware reset..
