Return-Path: <linux-kernel-owner+w=401wt.eu-S1759108AbZFIUjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759108AbZFIUjT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 16:39:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755549AbZFIUjM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 16:39:12 -0400
Received: from mail-qy0-f190.google.com ([209.85.221.190]:44640 "EHLO
	mail-qy0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755421AbZFIUjL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 16:39:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=ggDHrXXR+4pB0NQX5aFXwMUqGitgr8QoeRaYFoKPeqeiBeSo2/yGW1szI4rVXypTzY
         heKLLdmQAk8xzgvN7EpRFPio2JUzQ0mfKgUk/X8TnEE/dcRnMnlAuF9seVn1wl9jsRIh
         PMdgWJ3i/WNv4VpW2CdW5vGiNftOGAztjNtas=
MIME-Version: 1.0
In-Reply-To: <20090609195100.GY19203@electro-mechanical.com>
References: <20090609195100.GY19203@electro-mechanical.com>
Date: Tue, 9 Jun 2009 16:39:12 -0400
X-Google-Sender-Auth: 8eaf732bdca00144
Message-ID: <b6c5339f0906091339j3784c36bxe888af16272fbcde@mail.gmail.com>
Subject: Re: 3com 3crxjk10075 with ath5k driver
From: Bob Copeland <me@bobcopeland.com>
To: William Thompson <wt@electro-mechanical.com>
Cc: linux-kernel@vger.kernel.org, ath5k-devel <ath5k-devel@venema.h4ckr.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[CCed ath5k-devel]

On Tue, Jun 9, 2009 at 3:51 PM, William
Thompson<wt@electro-mechanical.com> wrote:
> This card has the "xjack" antennae which is supposed to disable the radio (I
> thought it was in hardware, but it's not) when it is not extended.  The
> madwifi driver (Last time I actually used this card with it) did disable the
> radio (Or refused packets, not sure which).

Huh, I wonder how that works.  Is disabling the radio an advertised feature?
i.e. as opposed to just not working because the antenna is in?

> The kernel ath5k driver (last tested 2.6.29.4) will work regardless if the
> antannae is in or out.

I suppose it could be asserting something on rfkill gpios; ath5k hasn't had
real rfkill support yet.  Anyone else know about these devices?

-- 
Bob Copeland %% www.bobcopeland.com
