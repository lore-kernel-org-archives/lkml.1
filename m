Return-Path: <linux-kernel-owner+w=401wt.eu-S932122AbZEDQRi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932122AbZEDQRi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 12:17:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758171AbZEDQRW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 12:17:22 -0400
Received: from qw-out-2122.google.com ([74.125.92.24]:34003 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757318AbZEDQRU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 12:17:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=MG3+nHVIyV/XJj4/9c8uYHtuun/4mmEeQGPMM2KG8YMOG1u0adMUXXqpasoMlnC2hX
         h+yP8ZhiLOSHdwzJ65IWBZ2OkA/Ifm3Lh39cOa0/qMWw3TEmx7Dw9xRoW3b3vso/kICN
         VRcGgQOd9Wsoz+wIh1Bkzw8u8HoAIQWslhK2Y=
MIME-Version: 1.0
In-Reply-To: <1241453096-8517-1-git-send-email-jirislaby@gmail.com>
References: <1241453096-8517-1-git-send-email-jirislaby@gmail.com>
Date: Mon, 4 May 2009 12:17:19 -0400
X-Google-Sender-Auth: 3eda8b11ed909c75
Message-ID: <b6c5339f0905040917s72b9f515h40be93fbf04c2182@mail.gmail.com>
Subject: Re: [PATCH 1/2] mac80211: minstrel, fix memory corruption
From: Bob Copeland <me@bobcopeland.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org, Felix Fietkau <nbd@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 4, 2009 at 12:04 PM, Jiri Slaby <jirislaby@gmail.com> wrote:
> minstrel doesn't count max rate count in fact, since it doesn't use
> a loop variable `i' and hence allocs space only for bitrates found in
> the first band.

Nice catch, I don't know how many times I read that and didn't see
it.  Hopefully that has some bearing on this long standing bug:

http://bugzilla.kernel.org/show_bug.cgi?id=12490

-- 
Bob Copeland %% www.bobcopeland.com
