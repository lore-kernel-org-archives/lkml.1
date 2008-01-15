Return-Path: <linux-kernel-owner+w=401wt.eu-S1758226AbYAOWEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758226AbYAOWEU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 17:04:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756394AbYAOWEM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 17:04:12 -0500
Received: from an-out-0708.google.com ([209.85.132.249]:53893 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755953AbYAOWEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 17:04:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=hPzIGQz2QJdgGgwbkv3yxMO7667ciLwdF7sPxu5r7ANjGuHfkCsU3dWUqR3XPTSf6t/fv48yG2Ci8w70rB0rEsVzEAHn8ifQJkD5CrIJBPY3YbAkXCkhpbRTmFO4CTIkIHVJvRlFNhRC+WuYzcXeG9NRI0v7ZbYDilMuMQutNeM=
Date: Tue, 15 Jan 2008 17:04:01 -0500
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Andres Salomon <dilinger@queued.net>
Cc: linux-input@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: psmouse: fix input_dev leak in lifebook driver
Message-ID: <20080115170323.ZZRA012@mailhub.coreip.homeip.net>
References: <20080112151252.193d6b52@ephemeral>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080112151252.193d6b52@ephemeral>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 12, 2008 at 03:12:52PM -0500, Andres Salomon wrote:
> 
> The lifebook driver may register a second input device, but it never
> unregisters it.  This fixes that.
> 
> Signed-off-by: Andres Salomon <dilinger@debian.org>

Applied, thank you Andres.

-- 
Dmitry

