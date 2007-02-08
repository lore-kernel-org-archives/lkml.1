Return-Path: <linux-kernel-owner+w=401wt.eu-S1752374AbXBHSFT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752374AbXBHSFT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 13:05:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752380AbXBHSFS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 13:05:18 -0500
Received: from wr-out-0506.google.com ([64.233.184.237]:6997 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752374AbXBHSFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 13:05:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=QBqo9+7PyIVisJMtr/EUMSrzY3eFq/eYzkIHGoxOtcr+QT3ciePB7oX2kYIadWtf9qsFl0DLBtWIcsYBrFx54L3gSeLHXj6vGN9H4ktHlaRqPyalGGim/pOa+1is1l5UaZLI/R4cbu88v/ix/9P+yYrUbEsHZ9ZUMwKJ15jgJ3M=
Message-ID: <8474209b0702081005t196c64bajbf94f119e4ed32e@mail.gmail.com>
Date: Thu, 8 Feb 2007 20:05:15 +0200
From: "Alex Bounder" <abounder@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: creating headless device on 2.6.18
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, all.
 I'm trying to create a headless device based on kernel 2.6.18 (FEDORA
distro). What I need is to guarantee that LINUX kernel do not access
the graphical adapter (used by another OS).
My idea was to remove from .config everything that is graphic related.
Yet there are two flags, which are "irremovable". These are
:CONFIG_VGA_CONSOLE and CONFIG_VIDEO_V4L2. The only option for them is
[y]. Can anyone help me to get rid of them or suggest another way of
"blocking" the graphical adapter?
Thanks in advance,
 Alex.
