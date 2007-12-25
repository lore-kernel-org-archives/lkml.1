Return-Path: <linux-kernel-owner+w=401wt.eu-S1752037AbXLYXrs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752037AbXLYXrs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2007 18:47:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751204AbXLYXrk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Dec 2007 18:47:40 -0500
Received: from ozlabs.org ([203.10.76.45]:42679 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751198AbXLYXrk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2007 18:47:40 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: Re: [PATCH 09/16] map_switcher_in_guest() per-vcpu
Date: Wed, 26 Dec 2007 10:47:35 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: lguest@ozlabs.org, glommer@gmail.com, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org, rostedt@goodmis.org
References: <11981576363806-git-send-email-gcosta@redhat.com> <1198157678759-git-send-email-gcosta@redhat.com> <11981576833314-git-send-email-gcosta@redhat.com>
In-Reply-To: <11981576833314-git-send-email-gcosta@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712261047.35810.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 21 December 2007 00:33:49 Glauber de Oliveira Costa wrote:
> The switcher needs to be mapped per-vcpu, because different vcpus
> will potentially have different page tables (they don't have to,
> because threads will share the same).
>
> So our first step is the make the function receive a vcpu struct

Hmm, I wonder if we should call it lg_vcpu: lguest_vcpu is a little long, and 
in total adds a fair number of lines to the code :)

Rusty.
