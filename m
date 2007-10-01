Return-Path: <linux-kernel-owner+w=401wt.eu-S1753276AbXJAJrY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276AbXJAJrY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 05:47:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751200AbXJAJrS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 05:47:18 -0400
Received: from coyote.holtmann.net ([217.160.111.169]:52006 "EHLO
	mail.holtmann.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120AbXJAJrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 05:47:17 -0400
Subject: Re: bluetooth: hci_sysfs work queue problem
From: Marcel Holtmann <marcel@holtmann.org>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: bluez-devel@lists.sourceforge.net, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <a8e1da0709291846x4abf50c8g32b02a9d40240b6@mail.gmail.com>
References: <a8e1da0709291846x4abf50c8g32b02a9d40240b6@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 01 Oct 2007 11:45:56 +0200
Message-Id: <1191231956.6484.104.camel@aeonflux.holtmann.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

> The hci_sysfs uses work queue to finish the sysfs add/del fuction.
> But when the same device connection failed, if another connection of
> same device come in before the delete work finish, sysfs will warn
> about duplicate filename creating.

which kernel are we talking about. This problem should not exist
anymore. However the usage of a work queue is unavoidable.

Regards

Marcel


