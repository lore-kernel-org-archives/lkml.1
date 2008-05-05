Return-Path: <linux-kernel-owner+w=401wt.eu-S1761869AbYEEWGt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761869AbYEEWGt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 18:06:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755686AbYEEWGi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 18:06:38 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44921 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752186AbYEEWGh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 18:06:37 -0400
Date: Mon, 5 May 2008 18:06:29 -0400
From: Rik van Riel <riel@redhat.com>
To: "Kevin Burton" <burton@tailrank.com>
Cc: "Chris Friesen" <cfriesen@nortel.com>, "FD Cami" <francois.cami@free.fr>,
       linux-kernel@vger.kernel.org
Subject: Re: Ability to limit or disable page caching?
Message-ID: <20080505180629.3b60c5fb@cuia.bos.redhat.com>
In-Reply-To: <30c6373b0805051432k2c5c3311vffb10fdf2a0ac1cd@mail.gmail.com>
References: <30c6373b0805050012o505c0540i116a31bc1ab9ce9f@mail.gmail.com>
	<20080505131607.5556b1f2@olorin>
	<30c6373b0805051134m634efbbdn45167c1eae29df4a@mail.gmail.com>
	<20080505212831.22371732@olorin>
	<30c6373b0805051242o2f38f0a3v62bd43f4fa01559e@mail.gmail.com>
	<20080505164446.2ec9a543@cuia.bos.redhat.com>
	<481F7613.6040809@nortel.com>
	<30c6373b0805051432k2c5c3311vffb10fdf2a0ac1cd@mail.gmail.com>
Organization: Red Hat, Inc
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 May 2008 14:32:41 -0700
"Kevin Burton" <burton@tailrank.com> wrote:

> I'd like to be able to disable the cache altogether.....  It seems
> like an easy tunable to add and might help benefit future testing.

Executables, libraries, shared memory segments, directories and all kinds
of other things live in the page cache.  You cannot disable it without
breaking the most basic functionality.

-- 
All Rights Reversed
