Return-Path: <linux-kernel-owner+w=401wt.eu-S1761134AbXEJUjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761134AbXEJUjT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 16:39:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755354AbXEJUjM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 16:39:12 -0400
Received: from nz-out-0506.google.com ([64.233.162.227]:60036 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755479AbXEJUjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 16:39:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:openpgp:content-type:content-transfer-encoding;
        b=pHnTEy8H2o0XcjxhQ3JeM7oX3P+9EyW+7NyWgIOGPzoLy9dYb1DsH5dRhER8YHcRjXqCFGNqgPIIvXyuGhpJjQMpn4YHKX48P0JH80IokB5akZ1IxD1MzZ0Yj81BVpCiPf21xMK6rEeUfuG0tzmIEu0JD+6hicOp23NTJXbUnZA=
Message-ID: <464382DE.5020206@gmail.com>
Date: Fri, 11 May 2007 02:08:54 +0530
From: jimmy bahuleyan <knight.camelot@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Jonathan Corbet <corbet@lwn.net>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Jesper Juhl <jesper.juhl@gmail.com>,
       Randy Dunlap <randy.dunlap@oracle.com>, Heikki Orsila <shdl@zakalwe.fi>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Satyam Sharma <satyam.sharma@gmail.com>
Subject: Re: [PATCH] "volatile considered harmful", take 2
References: <6143.1178828419@lwn.net>
In-Reply-To: <6143.1178828419@lwn.net>
X-Enigmail-Version: 0.95.0
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jonathan Corbet wrote:
[snip..]
> +
> +  - The jiffies variable is special in that it can have a different value
> +    every time it is referenced, but it can be read without any special
> +    locking.  So jiffies can be volatile, but the addition of other
> +    variables of this type is strongly frowned upon.  Jiffies is considered
> +    to be a "stupid legacy" issue in this regard.

Why is it that you consider jiffies to be a "stupid legacy"? Isn't it
natural to have a externally modified variable which is only /read/ to
be volatile? (or is jiffies supposed to be replaced with something
smarter/better :)


-jb
-- 
Tact is the art of making a point without making an enemy.
