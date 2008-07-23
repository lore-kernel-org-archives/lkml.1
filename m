Return-Path: <linux-kernel-owner+w=401wt.eu-S1753745AbYGWMQr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753745AbYGWMQr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 08:16:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751734AbYGWMQh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 08:16:37 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:5938 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959AbYGWMQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 08:16:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=i1oRN/omW+rUHREgTecA51qJFhhgPPU4EGvjPETMdcaJnyNEMRLf2mhYX+6fG3E46a
         W/4+0DwO/5GLAnyi9M3UkFtRaWe/S5No+KVp7ZtUo8oyR4dW+kZfTL6dGJmnoeA15b8Z
         fUc1cwYjKBPWiy/UwJwo8P//usXj8NX6FUm0I=
Message-ID: <b6c5339f0807230516g7594143aia1f7c796f49e2a72@mail.gmail.com>
Date: Wed, 23 Jul 2008 08:16:35 -0400
From: "Bob Copeland" <me@bobcopeland.com>
To: "Jiri Slaby" <jirislaby@gmail.com>
Subject: Re: [ath5k-devel] [PATCH 1/3] Ath5k: fix beacon-update deadlock
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org, ath5k-devel@venema.h4ckr.net,
       "Johannes Berg" <johannes@sipsolutions.net>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <1216811855-9387-1-git-send-email-jirislaby@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1216811855-9387-1-git-send-email-jirislaby@gmail.com>
X-Google-Sender-Auth: eb67c5d5f6a40da8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2008 at 7:17 AM, Jiri Slaby <jirislaby@gmail.com> wrote:
> Commit 9d139c810a2aa17365cc548d0cd2a189d8433c65 introduced
> AA deadlock -- ath5k_config_interface(); holds sc->lock
> and it calls ath5k_beacon_update(); which tries to grab the
> lock again.

I already posted a patch for this a few days ago, did it get picked up?

-- 
Bob Copeland %% www.bobcopeland.com
