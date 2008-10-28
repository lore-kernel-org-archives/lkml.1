Return-Path: <linux-kernel-owner+w=401wt.eu-S1754300AbYJ1PNg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754300AbYJ1PNg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 11:13:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751930AbYJ1PNW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 11:13:22 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:39829 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673AbYJ1PNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 11:13:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=Ywp+rulAExlMtaMg5dgcUG4PgxRePzbk/YfFkTYz1K5CofgIjANlWafcVItufYHVi7
         4Jh3mDB6buL15ukQMlFW7olDtYpDqfXxxAOZTTU05uJeroDIAYXxybA4yf+8LwV2DNIc
         yPVlTQxLwES/t8N7KNjetZaqeqwpKK5mvZsLI=
Message-ID: <b6c5339f0810280813k4b378678ic10d26281bf4f170@mail.gmail.com>
Date: Tue, 28 Oct 2008 11:13:20 -0400
From: "Bob Copeland" <me@bobcopeland.com>
To: "Arjan van de Ven" <arjan@infradead.org>
Subject: Re: [PATCH] wireless: fix regression caused by regulatory config option
Cc: torvalds@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, rjw@sisk.pl, rodriguez@atheros.com,
       johannes@sipsolutions.net
In-Reply-To: <20081026103024.2712ddc9@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081026103024.2712ddc9@infradead.org>
X-Google-Sender-Auth: 0af878399d3a2db9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -         Say N unless you cannot install a new userspace application
> -         or have one currently depending on the ieee80211_regdom module
> -         parameter and cannot port it to use the new userspace interfaces.
> -
> -         This is scheduled for removal for 2.6.29.
> +         Say Y unless you have installed a new userspace application.
> +         Also say Y if have one currently depending on the ieee80211_regdom
> +         module parameter and cannot port it to use the new userspace
> +         interfaces.

Ignoring the main debate :) -- I might point out the actual help text here in
is a bit user-unfriendly.  "installed a new userspace application" (which? I
just installed Firefox, does that count?)  "Also say Y if [you] have [an
application]..."

-- 
Bob Copeland %% www.bobcopeland.com
