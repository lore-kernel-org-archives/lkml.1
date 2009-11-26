Return-Path: <linux-kernel-owner+w=401wt.eu-S1760302AbZKZKuL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760302AbZKZKuL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 05:50:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751342AbZKZKuJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 05:50:09 -0500
Received: from bhuna.collabora.co.uk ([93.93.128.226]:60111 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150AbZKZKuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 05:50:08 -0500
From: Ian Molton <ian.molton@collabora.co.uk>
To: linux-kernel@vger.kernel.org
Cc: rusty@rustcorp.com.au, mpm@selenic.com, jeff@garzik.org
Subject: 
Date: Thu, 26 Nov 2009 10:49:29 +0000
Message-Id: <1259232570-11918-1-git-send-email-ian.molton@collabora.co.uk>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <1259197403.2858.88.camel@calx>
References: <1259197403.2858.88.camel@calx>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

	This version uses a statically allocated buffer. I dont feel it is a
good idea not to pass the address and length of the buffer to the hardware
drivers, as they shouldnt have intimate knowledge of the core, IMO.

Only resendiong the core patch, the virtio-rng driver hasnt changed.

hw_random: core updates to allow more efficient drivers

-Ian
