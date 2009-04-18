Return-Path: <linux-kernel-owner+w=401wt.eu-S1757749AbZDRItt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757749AbZDRItt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 04:49:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753137AbZDRItl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 04:49:41 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:42899 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752826AbZDRItl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 04:49:41 -0400
From: Oliver Neukum <oliver@neukum.org>
To: "Peter Holik" <peter@holik.at>
Subject: Re: [PATCH] usb driver for intellon based PLC like devolo dlan duo
Date: Sat, 18 Apr 2009 10:49:55 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.27.7-9-default; KDE/4.1.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <2c05d20b7e24c4bf9cbfba19b9891f70.squirrel@webmail.it-technology.at> <200904180938.48276.oliver@neukum.org> <0d3ceee0bebd3c68fb0d568239117425.squirrel@webmail.it-technology.at>
In-Reply-To: <0d3ceee0bebd3c68fb0d568239117425.squirrel@webmail.it-technology.at>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904181049.55812.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag 18 April 2009 10:41:37 schrieb Peter Holik:
> > Without the "|". Just dereference the pointer.
>
> this way?
>
> len = le16_to_cpu(*(__le16 *)&skb->data[skb->len - 2]);

That does the job.

	Regards
		Oliver

