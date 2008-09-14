Return-Path: <linux-kernel-owner+w=401wt.eu-S1755150AbYINPSm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755150AbYINPSm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 11:18:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753137AbYINPSe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 11:18:34 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:57380 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753131AbYINPSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 11:18:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Yu7oTkDtHr3K2lE5KtSnnMU495AbCdjwVb6dyDIfxeUhssxFuVY7vUeo9p62Elyik9
         sFihaYSw9ztaq3vl/kcIe0Hnms0OqePTAmfUmcfLwc8eJX6QKp5m0OY07hNMFeZxg7OS
         wQ6u+2tIqrVxTyIuef7yARATUjcEnmNtpZ/m4=
Date: Sun, 14 Sep 2008 11:18:26 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: akpm@osdl.org, linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: bcm5974: Switch back to normal mode when closing
Message-ID: <20080914151824.GB5391@amd.corenet.prb>
References: <48CD25C3.8050008@euromail.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48CD25C3.8050008@euromail.se>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Henrik,

On Sun, Sep 14, 2008 at 04:54:59PM +0200, Henrik Rydberg wrote:
> Staying in multi-touch mode after closing the device sometimes makes the keyboard drop keys or
> repeat keys irratically. The conjecture is that some internal buffer starts to overflow,
> resulting in undefined behavior. Switching back to normal mode when closing the device makes the
> problem go away.
> 

Makes sense, will apply.

-- 
Dmitry
