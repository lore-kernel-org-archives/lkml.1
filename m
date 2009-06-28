Return-Path: <linux-kernel-owner+w=401wt.eu-S1752958AbZF1KjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752958AbZF1KjU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 06:39:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751804AbZF1KjL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 06:39:11 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:53971 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406AbZF1KjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 06:39:10 -0400
MIME-Version: 1.0
In-Reply-To: <200906280821.58631.info@gnebu.es>
References: <200906280821.58631.info@gnebu.es>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Sun, 28 Jun 2009 12:37:28 +0200
Message-ID: <ac3eb2510906280337s57f5a48kc487a85d259f83dd@mail.gmail.com>
Subject: Re: Kernel 2.6.30 and udevd problem
To: Alberto Gonzalez <alberto6674@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-hotplug@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 28, 2009 at 08:21, Alberto Gonzalez<alberto6674@gmail.com> wrote:
> I have recently upgraded my kernel to 2.6.30 and I've noticed that at some
> point (randomly), udevd would start using a lot of CPU time. Killing the
> process and starting it with --debug option prints these messages when the
> problem starts:
>
> [22652] event_queue_insert: seq 168515 queued, 'change' 'drm'

Care to run:
  udevadm monitor
and provide the output of the event sequence dump?

Kay
