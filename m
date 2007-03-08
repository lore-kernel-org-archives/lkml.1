Return-Path: <linux-kernel-owner+w=401wt.eu-S1752527AbXCHQnr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752527AbXCHQnr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 11:43:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752526AbXCHQnr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 11:43:47 -0500
Received: from wavehammer.waldi.eu.org ([82.139.201.20]:44446 "EHLO
	wavehammer.waldi.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752521AbXCHQnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 11:43:46 -0500
X-Greylist: delayed 1719 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Mar 2007 11:43:46 EST
Date: Thu, 8 Mar 2007 17:15:02 +0100
From: Bastian Blank <bastian@waldi.eu.org>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [Patch 1/2] add for_each_substring() and match_substring()
Message-ID: <20070308161502.GA19326@wavehammer.waldi.eu.org>
Mail-Followup-To: Bastian Blank <bastian@waldi.eu.org>,
	linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
References: <1173208763.5266.8.camel@dix>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1173208763.5266.8.camel@dix>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 06, 2007 at 08:19:23PM +0100, Martin Peschke wrote:
> +char *match_to(const char *cs, const char *ct)
> +{
> +	char *delim = strpbrk(cs, ct);
> +	if (delim)
> +		return delim;
> +	else if (*cs != '\0')
> +		return (char *)(cs + strlen(cs));

This disallows the use of match_to with a real constant char array,
please remove the const from the prototyp.

Bastian

-- 
	"Get back to your stations!"
	"We're beaming down to the planet, sir."
		-- Kirk and Mr. Leslie, "This Side of Paradise",
		   stardate 3417.3
