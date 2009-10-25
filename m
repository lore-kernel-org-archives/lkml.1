Return-Path: <linux-kernel-owner+w=401wt.eu-S1753946AbZJYTuE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946AbZJYTuE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Oct 2009 15:50:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752815AbZJYTuE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Oct 2009 15:50:04 -0400
Received: from smtp-out002.kontent.com ([81.88.40.216]:45395 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752455AbZJYTuD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Oct 2009 15:50:03 -0400
From: Oliver Neukum <oliver@neukum.org>
To: bart.hartgers@gmail.com
Subject: Re: [PATCH 3/7] ark3116: (3rd try) Replace cmget
Date: Sun, 25 Oct 2009 20:52:08 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.31-rc9-0.1-default; KDE/4.1.3; x86_64; ; )
Cc: "Greg Kroah-Hartman" <gregkh@suse.de>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <20091025175057.270011110@gmail.com> <20091025175321.276761473@gmail.com>
In-Reply-To: <20091025175321.276761473@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200910252052.09845.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, 25. Oktober 2009 18:51:00 schrieb bart.hartgers@gmail.com:
> +       /* read modem status */
> +       unsigned status = atomic_read(&priv->msr);
> +       /* modem control is output */
> +       unsigned ctrl = atomic_read(&priv->mcr);

What is the sense of having two atomic variables?
You can get races where one is changed but the other is not.

	Regards
		Oliver

