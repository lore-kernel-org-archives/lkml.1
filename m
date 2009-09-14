Return-Path: <linux-kernel-owner+w=401wt.eu-S1755399AbZINMBx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755399AbZINMBx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 08:01:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755230AbZINMBw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 08:01:52 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:38047 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276AbZINMBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 08:01:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=b4zrtVvAnfJnLIg87N0eP5LQo51WMIu5qCPUFA2IJTiAYwB02U6X4A2OlCPILVPH2u
         5IVcDdc5WQC2knOP/lOU0yKFJvttKUhzFPSStDWwpmcKWZx70OvrTWDsy3gBGi4ZTUxC
         e8wWPDStGT55pTIu/7xr0EGFF1xczcyCIDFJ0=
From: Corentin Chary <corentincj@iksaif.net>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Subject: Re: [PATCH 3/3] dell-laptop: fix rfkill memory leak on unload
Date: Mon, 14 Sep 2009 14:01:58 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-gentoo; KDE/4.3.1; x86_64; ; )
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, linux-acpi@vger.kernel.org,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       Julia Lawall <julia@diku.dk>, Johannes Berg <johannes@sipsolutions.net>
References: <1252925033-29696-1-git-send-email-corentincj@iksaif.net> <20090914104616.GA6170@srcf.ucam.org> <4AAE22CF.1020609@tuffmail.co.uk>
In-Reply-To: <4AAE22CF.1020609@tuffmail.co.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200909141401.58428.corentincj@iksaif.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 14 September 2009 13:02:39 Alan Jenkins wrote:
> Matthew Garrett wrote:
> > On Mon, Sep 14, 2009 at 12:43:53PM +0200, Corentin Chary wrote:
> >> rfkill_unregister() should always be followed by rfkill_destroy()
> >>
> >> Cc: Matthew Garrett <mjg@redhat.com>
> >> Signed-off-by: Corentin Chary <corentincj@iksaif.net>
> >
> > Acked-by: Matthew Garrett <mjg@redhat.com>
> 
> I can endorse this as I already submitted something similar :-).
> <http://patchwork.kernel.org/patch/42699/> (with a disclaimer that it
> was not tested on dell hardware).

I haven't seen your patch, sorry :/

It also conflicts with http://patchwork.kernel.org/patch/42705/ (I set 
wlan_rfkill to NULL to avoid use-after-free).

Let's drop this patch and merge your series

-- 
Corentin Chary
http://xf.iksaif.net
