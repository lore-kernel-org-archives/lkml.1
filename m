Return-Path: <linux-kernel-owner+w=401wt.eu-S1758351AbYFDGvr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758351AbYFDGvr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 02:51:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751722AbYFDGvk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 02:51:40 -0400
Received: from senator.holtmann.net ([87.106.208.187]:41883 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529AbYFDGvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 02:51:39 -0400
Subject: Re: [PATCH 2/2] bluetooth: hci_bcsp.c small cleanups/api users
From: Marcel Holtmann <marcel@holtmann.org>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1212517161.11008.60.camel@brick>
References: <1212517161.11008.60.camel@brick>
Content-Type: text/plain
Date: Wed, 04 Jun 2008 08:53:44 +0200
Message-Id: <1212562424.6339.3.camel@californication>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Harvey,

> Use bitrev16 from lib/bitrev.c.
> 
> Use the get_unaligned_be16 to get the crc from the packet, create a
> small helper function for this.
> 
> Fix a shadowed variable sparse warning:
> drivers/bluetooth/hci_bcsp.c:218:26: warning: symbol 'hdr' shadows an earlier one
> drivers/bluetooth/hci_bcsp.c:187:5: originally declared here
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>

Acked-by: Marcel Holtmann <marcel@holtmann.org>

Regards

Marcel


