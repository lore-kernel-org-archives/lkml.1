Return-Path: <linux-kernel-owner+w=401wt.eu-S1757642AbYF3MVr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757642AbYF3MVr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 08:21:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761434AbYF3MVi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 08:21:38 -0400
Received: from an-out-0708.google.com ([209.85.132.248]:26782 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757368AbYF3MVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 08:21:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Ca7cO4jM3lmNg2usVZ/GEoWNwdSKbDVo+UMua8mU4eh7YEOeCYqlrNzji7jsRi9+Sa
         pfZ5JD+YWSwIYeEDicWJLAXbxkDtHVV/TNfX+OE1WivbzWrrIB8my1g8WGqgjaWwhaI8
         YcHzheP+9RLlbCO5l5Ru890oQiXyjnqvlVoIg=
Date: Mon, 30 Jun 2008 08:21:30 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: vojtech@suse.cz, linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] atkbd.c: make the unknown key warnings controllable
	thru a config option
Message-ID: <20080630081937.ZZRA012@mailhub.coreip.homeip.net>
References: <20080629225423.A23524@ward.six>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080629225423.A23524@ward.six>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Denis,

On Sun, Jun 29, 2008 at 10:54:23PM +0600, Denis Zaitceff wrote:
> The patch allows to configure off the logging of ATKBD_KEY_UNKNOWN
> events.  This logging can be healthy, but usually it just pollutes the
> kernel log.  And this logging may be _very_ massive.
> 

You can easily shut off the warnings by actually mapping the key,
so there is no need to add a new config option.

Thanks.

-- 
Dmitry
