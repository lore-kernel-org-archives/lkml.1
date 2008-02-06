Return-Path: <linux-kernel-owner+w=401wt.eu-S1756375AbYBFR3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756375AbYBFR3W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 12:29:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754149AbYBFR3K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 12:29:10 -0500
Received: from wr-out-0506.google.com ([64.233.184.235]:54971 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753980AbYBFR3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 12:29:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:bcc:subject:reply-to:in-reply-to:message-id;
        b=FUVO/CLgxK4KQADyr4lt0qCwFcUCEH9/kldL7JyoXfRWZWU9bQt6aU15/2ygkWiVU7xGNaZ5WiQ0cOLySttVaROe8B/cT7wZNE+8NSEHaGBrK5Df06irVjhYyaZUm6UjexyRjYLP/+tgmRu1Uqqj5fhSgfAh6n26eRqtkBcJSnc=
Date: Wed,  6 Feb 2008 09:36:11 -0800
From: Glenn Griffin <ggriffin.kernel@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Glenn Griffin <ggriffin.kernel@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add IPv6 support to TCP SYN cookies
In-Reply-To: <20080206075030.GA454@one.firstfloor.org>
Message-ID: <47a9ee5e.15538c0a.7043.05ba@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I didn't think a module could have multiple module_inits. Are you
> sure that works?

Indeed.  That will fail whenever ipv6 is compiled as a module.  It's
been removed.  It snuck in from the v4 implementation, where I'm still
having trouble understanding why it's needed there.

--Glenn
