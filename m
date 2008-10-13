Return-Path: <linux-kernel-owner+w=401wt.eu-S1758221AbYJNAAm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758221AbYJNAAm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 20:00:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757579AbYJNAAd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 20:00:33 -0400
Received: from mx2.redhat.com ([66.187.237.31]:40555 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757239AbYJNAAc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 20:00:32 -0400
Date: Mon, 13 Oct 2008 19:59:23 -0400
From: Chuck Ebbert <cebbert@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Takashi Iwai <tiwai@suse.de>
Subject: The snd-aw2 audio driver conflicts with saa7146-based video
 adapters
Message-ID: <20081013195923.361f3726@redhat.com>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

snd-aw2 ("Emagic Audiowerk 2 sound driver") matches on PCI ID for any board
containing an saa7146 chip. When the driver loads it blocks the proper driver
from loading. It also blindly assumes that it is driving an aw2 adapter and
just starts writing to various I/O ports...
