Return-Path: <linux-kernel-owner+w=401wt.eu-S964932AbXA3Dsp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964932AbXA3Dsp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 22:48:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964982AbXA3Dsp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 22:48:45 -0500
Received: from old-tantale.fifi.org ([64.81.251.130]:33688 "EHLO
	tantale.fifi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964932AbXA3Dso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 22:48:44 -0500
X-Greylist: delayed 469 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Jan 2007 22:48:43 EST
To: "Yakov Lerner" <iler.ml@gmail.com>
Cc: "Kernel Linux" <linux-kernel@vger.kernel.org>
Subject: Re: software read-only flag for rw partition or disk ?
References: <f36b08ee0701290102kd5c4ab1hef861cb3de9f042d@mail.gmail.com>
Mail-Copies-To: nobody
From: Philippe Troin <phil@fifi.org>
Date: 29 Jan 2007 19:44:15 -0800
In-Reply-To: <f36b08ee0701290102kd5c4ab1hef861cb3de9f042d@mail.gmail.com>
Message-ID: <877iv5uqk0.fsf@tantale.fifi.org>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.2
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Yakov Lerner" <iler.ml@gmail.com> writes:

> Does /proc have any entries to flip the "software read-only flag"
> for a partition or disk (which are physically read-write) ?

No, but you can use blockdev --setro /dev/hdXX

Phil.
