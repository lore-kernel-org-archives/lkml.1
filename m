Return-Path: <linux-kernel-owner+w=401wt.eu-S1760496AbYETGjK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760496AbYETGjK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 02:39:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754696AbYETGi4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 02:38:56 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:22618 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753588AbYETGi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 02:38:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=hbcSCqNXBCr9BDiuJysgy/wf3IbDOAxo5JXqpDy4OExcreCtj6mQvk3i7ZL9rvlHjzmPHHZP7uEAEOu9lNcQ+E3sx0dCbA8RclJODe5uZIbF1mPifSRzbvxSLq5J56Zevax0PGhNsySwxVpTCAqpDXffy11lL2F018gkoWVYpQc=
Subject: Re: [Bug 10620] VT switching broken - X does not resume (intel
	chipset)
From: Romano Giannetti <romano.giannetti@gmail.com>
To: bugme-daemon@bugzilla.kernel.org
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20080519214445.BEE7E108062@picon.linux-foundation.org>
References: <20080519214445.BEE7E108062@picon.linux-foundation.org>
Content-Type: text/plain
Date: Tue, 20 May 2008 08:38:47 +0200
Message-Id: <1211265527.8773.8.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-05-19 at 14:44 -0700, bugme-daemon@bugzilla.kernel.org
wrote:
> Notice that git bisect accepts a path, so that it will only bisect between the
> commits that affect to a given path. If you are sure that it's a drm-related
> thing, you can try to do bisection on drivers/char/drm

I know. The problem was that I didn't know if this was due to the drm,
video, acpi or x86... so it seems that is quite restricted now.

To resume (see http://bugzilla.kernel.org/show_bug.cgi?id=10620 )

- VT switching is broken after gnome has started (acceleration?)

- the symptom is that the X VT stays black, which just the cursor (and
sometime some residual bit of the panel) shown.

- it happens almost all the time with suspend/resume

- sometime you can kill the X server with ctrl-alt-backspace, sometime
you have to reboot.

My (painful) bisect stopped here:

good 50704516f334d5036c09b0ecc0064598f7c5596f
bad  d9c04d678418fe42646de641f499209ca00fd94f

but then 2c14f28be2a3f2a2e9861b156d64fbe2bc7000c3 makes my laptop oops on boot.

Romano




