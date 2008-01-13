Return-Path: <linux-kernel-owner+w=401wt.eu-S1752789AbYAMPOY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752789AbYAMPOY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 10:14:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751506AbYAMPOQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 10:14:16 -0500
Received: from rv-out-0910.google.com ([209.85.198.184]:60775 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291AbYAMPOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 10:14:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=jtvyTGRg4VF3mr8hTiyahixcd4LDhmo43C1TjZWqOGnehczWqfreVm6fHlsgZrMoaL6fLN+uIMdRi+NC/7r6yCiqyJid21d1DZWqWR+tHZIpTG5QW+1c688gEtY1uFx0Gc2+zL38fqaM1rGYW2Ku5RTqUlGHFJ3QfVdnwC/g3Xg=
Message-ID: <9e4733910801130714m1be16826jf240171972324d16@mail.gmail.com>
Date: Sun, 13 Jan 2008 10:14:14 -0500
From: "Jon Smirl" <jonsmirl@gmail.com>
To: "Jean Delvare" <khali@linux-fr.org>
Subject: Re: [i2c] [PATCH] update module-init-tools to support the i2c subsystem
Cc: i2c@lm-sensors.org, linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080113152735.5dca46a1@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9e4733910712171839h214e0bc3q179266c86e5987b1@mail.gmail.com>
	 <20080113152735.5dca46a1@hyperion.delvare>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/13/08, Jean Delvare <khali@linux-fr.org> wrote:
> On Mon, 17 Dec 2007 21:39:37 -0500, Jon Smirl wrote:
> > Follow on to: "Series to add device tree naming to i2c"
> > Teach module-init-tools about the i2c subsystem.
>
> Can you please explain what this patch does and why it is needed?

It generates the entries needed for the user space module tools to
work with the aliases. For example modprobe/depmod. It is a standard
part of the kernel module system.

-- 
Jon Smirl
jonsmirl@gmail.com
