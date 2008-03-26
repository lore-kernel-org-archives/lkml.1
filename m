Return-Path: <linux-kernel-owner+w=401wt.eu-S1758462AbYCZX2B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758462AbYCZX2B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 19:28:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757336AbYCZX1h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 19:27:37 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:41827 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757294AbYCZX1g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 19:27:36 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: what's the incompatibility between hibernation and hotplug memory
Date: Thu, 27 Mar 2008 00:27:25 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>
References: <47EAD9A7.6020609@goop.org>
In-Reply-To: <47EAD9A7.6020609@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803270027.26037.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 27 of March 2008, Jeremy Fitzhardinge wrote:
> Hi,

Hi,

> I noticed that Kconfig warns that hibernation and hotplug memory are not 
> compatible.  What's the issue?

Generally, we might not be able to handle memory unplugged at a wrong time
(eg. after we've created the image).

Which part of Kconfig says that exactly?

Rafael
