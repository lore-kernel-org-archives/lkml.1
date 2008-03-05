Return-Path: <linux-kernel-owner+w=401wt.eu-S1757773AbYCEQkN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757773AbYCEQkN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 11:40:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754700AbYCEQkA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 11:40:00 -0500
Received: from vena.lwn.net ([206.168.112.25]:49244 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754282AbYCEQj7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 11:39:59 -0500
To: device-mapper development <dm-devel@redhat.com>
Cc: Daniel Phillips <phillips@phunq.net>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] An alternative interface to device mapper 
From: corbet@lwn.net (Jonathan Corbet)
In-reply-to: Your message of "Wed, 05 Mar 2008 01:29:42 PST."
             <200803050129.43172.phillips@phunq.net> 
Date: Wed, 05 Mar 2008 09:39:59 -0700
Message-ID: <22778.1204735199@vena.lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Daniel,

> In more detail: ddlink is a generic pipe-like interface for controlling 
> device drivers.

I'm not in a position to say much about the wider picture at the moment,
but one quibble comes immediately to mind: why do you create yet another
communication path into the kernel rather than using netlink, which is
already there and used in a number of other contexts?

jon
