Return-Path: <linux-kernel-owner+w=401wt.eu-S1760135AbYEKXS7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760135AbYEKXS7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 19:18:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756503AbYEKXSw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 19:18:52 -0400
Received: from senator.holtmann.net ([87.106.208.187]:59475 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755861AbYEKXSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 19:18:51 -0400
Subject: Re: [PATCH 9/9] HID: add compat support
From: Marcel Holtmann <marcel@holtmann.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       anssi.hannula@gmail.com, akpm@linux-foundation.org,
       Sam Ravnborg <sam@ravnborg.org>
In-Reply-To: <1210536043-19812-9-git-send-email-jirislaby@gmail.com>
References: <1210536043-19812-1-git-send-email-jirislaby@gmail.com>
	 <1210536043-19812-2-git-send-email-jirislaby@gmail.com>
	 <1210536043-19812-3-git-send-email-jirislaby@gmail.com>
	 <1210536043-19812-4-git-send-email-jirislaby@gmail.com>
	 <1210536043-19812-5-git-send-email-jirislaby@gmail.com>
	 <1210536043-19812-6-git-send-email-jirislaby@gmail.com>
	 <1210536043-19812-7-git-send-email-jirislaby@gmail.com>
	 <1210536043-19812-8-git-send-email-jirislaby@gmail.com>
	 <1210536043-19812-9-git-send-email-jirislaby@gmail.com>
Content-Type: text/plain
Date: Mon, 12 May 2008 01:18:58 +0200
Message-Id: <1210547938.16390.37.camel@violet.holtmann.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

> Add compat option to hid code to allow loading of all modules on
> systems which don't allow autoloading because of old userspace.

this is pretty ugly. Please add a line to feature-removal-schedule.txt
to mark that this will be removed within the next 6 month. At that point
every distribution should have updated udev and module-init-tools.

Regards

Marcel


