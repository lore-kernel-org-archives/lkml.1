Return-Path: <linux-kernel-owner+w=401wt.eu-S933553AbZC0Arz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933553AbZC0Arz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 20:47:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933538AbZC0Arg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 20:47:36 -0400
Received: from outbound-mail-139.bluehost.com ([67.222.39.29]:40061 "HELO
	outbound-mail-139.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933537AbZC0Arg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 20:47:36 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=NjoelR4rpBFufd2jOdzGVijnieeTYgeFPN6ekxBKZrU5fRj/GjMbn5hE3jNMej/QFRc5UJVYsLJdVab+QkB1lFdkrHibINGJCmqLC/TT0NRC8MOLrBV8fONWI7UzVKKf;
Date: Thu, 26 Mar 2009 17:47:31 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Eric Anholt <eric@anholt.net>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.sourceforge.net,
       Eric Anholt <eric@anholt.net>
Subject: Re: [PATCH 2/6] drm/i915: Make GEM object's page lists refcounted
 instead of get/free.
Message-ID: <20090326174731.00b63466@hobbes>
In-Reply-To: <1238017510-26784-3-git-send-email-eric@anholt.net>
References: <1238017510-26784-1-git-send-email-eric@anholt.net>
	<1238017510-26784-2-git-send-email-eric@anholt.net>
	<1238017510-26784-3-git-send-email-eric@anholt.net>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Mar 2009 14:45:06 -0700
Eric Anholt <eric@anholt.net> wrote:

> We've wanted this for a few consumers that touch the pages directly
> (such as the following commit), which have been doing the refcounting
> outside of get/put pages.

Looks good, seems like it should be a small perf win also, did you
measure it?

Reviewed-by: Jesse Barnes <jbarnes@virtuousgeek.org>

-- 
Jesse Barnes, Intel Open Source Technology Center
