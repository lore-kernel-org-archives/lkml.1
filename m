Return-Path: <linux-kernel-owner+w=401wt.eu-S1753416AbZKLFur@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416AbZKLFur (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 00:50:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752679AbZKLFuq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 00:50:46 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:39099 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752577AbZKLFuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 00:50:46 -0500
MIME-Version: 1.0
Date: Thu, 12 Nov 2009 00:50:51 -0500
Message-ID: <58ccc7770911112150y4b5adebfq4401df46b20d2867@mail.gmail.com>
Subject: Keyboard driver not refreshing settings when unplugged.
From: Vincent Perricone <vhp@buffalo.edu>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I noticed a bug which may possibly be part of the Linux kernel.  If
one were to enable a setting on the keyboard(caps lock) and then
unplug that keyboard.  Upon re-plugging it in or another, the system
will still keep caps lock enabled.  When the user then goes and
enables caps lock on their own keyboard which assumes the setting is
disabled, the system then turns caps lock off, even though the user
wanted it on.

2.6.31-14-generic
