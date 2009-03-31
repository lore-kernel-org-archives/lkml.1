Return-Path: <linux-kernel-owner+w=401wt.eu-S1762654AbZCaVqj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762654AbZCaVqj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 17:46:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763549AbZCaVpr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 17:45:47 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:41068 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763546AbZCaVpq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 17:45:46 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH 2/2 V2] kaweth: Clean up code
Date: Tue, 31 Mar 2009 23:49:53 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.29-9-default; KDE/4.1.3; x86_64; ; )
Cc: jgarzik@pobox.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <49d26531.EsrSuMQHYRGUbhou%Larry.Finger@lwfinger.net>
In-Reply-To: <49d26531.EsrSuMQHYRGUbhou%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200903312349.53998.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag 31 März 2009 20:47:13 schrieb Larry Finger:
> The driver kaweth yields a -EBUSY error when starting, and a -ETIME
> error when shutting down. These errors are avoided, and the RX status
> is further checked for other potential errors.

Why the different treatment with respect to the error counter?
Isn't enough to print the numerical error? This takes a lot of
memory.

	Regards
		Oliver

