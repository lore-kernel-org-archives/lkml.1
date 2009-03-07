Return-Path: <linux-kernel-owner+w=401wt.eu-S1755105AbZCGMfS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755105AbZCGMfS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Mar 2009 07:35:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754644AbZCGMfC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Mar 2009 07:35:02 -0500
Received: from mail.deathmatch.net ([70.167.247.36]:3738 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754604AbZCGMfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Mar 2009 07:35:00 -0500
Date: Sat, 7 Mar 2009 07:34:38 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net,
       linux-kernel@vger.kernel.org,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [PATCH 2/2] ath5k: don't change mac in eeprom_read_mac on error
Message-ID: <20090307123438.GA13756@hash.localnet>
References: <1236418002-2189-1-git-send-email-jirislaby@gmail.com> <1236418002-2189-2-git-send-email-jirislaby@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236418002-2189-2-git-send-email-jirislaby@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 07, 2009 at 10:26:42AM +0100, Jiri Slaby wrote:
> Do not touch mac parameter passed to ath5k_eeprom_read_mac unless
> we are sure we have correct address. I.e. when returning error, do
> not change it.
> 
> While at it, use '= {}' compiler trick for memsetting mac_d.
> 
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> Cc: Nick Kossifidis <jirislaby@gmail.com>

Wrong email address for Nick :)  Otherwise,

Acked-by: Bob Copeland <me@bobcopeland.com>

-- 
Bob Copeland %% www.bobcopeland.com

