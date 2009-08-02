Return-Path: <linux-kernel-owner+w=401wt.eu-S1753391AbZHBUCI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391AbZHBUCI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 16:02:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753034AbZHBUCH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 16:02:07 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:8039 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752875AbZHBUCG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 16:02:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=UruKwR7glXcQ26JAEI2AJ6NBnJw1Uvkl3wZ65vjxI8nGcyuyKwqrAQh7Iz9UpiYceq
         M8Qfce+CYbE67aX5cPS9cHo/GnsbEYR1HhaOQgBzsqV30I0eNXxijdlJYJfbexv5HzYD
         j9EQ8lC9Dd4k/b8A6BrPj0z5nhU28Lh+p6Mrc=
MIME-Version: 1.0
In-Reply-To: <1249242398.32323.9.camel@wing-commander>
References: <1249242398.32323.9.camel@wing-commander>
Date: Sun, 2 Aug 2009 13:02:06 -0700
Message-ID: <364299f40908021302m4e2d0d12kf8b985313fe1cb60@mail.gmail.com>
Subject: Re: [ANNOUNCE] upstart 0.6.3 released
From: Garrett Cooper <yanegomi@gmail.com>
To: Scott James Remnant <scott@netsplit.com>
Cc: upstart-devel@lists.ubuntu.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 2, 2009 at 12:46 PM, Scott James Remnant<scott@netsplit.com> wrote:
> The biggest disadvantage to people actually using your software is that
> they find bugs, this one's a doozy because it looks like it affects
> older 0.3 releases as well.  Now seems as good a time as any to repeat
> my recommendation that distributions, mobile and embedded appliance
> developers using Upstart consider using 0.6 in their next release rather
> than sticking with 0.3
>
> I've also today created the 0.6 stable branch in bzr, those following
> stable releases with bzr will want to update their trees to
> lp:~scott/upstart/0.6.  New stable releases will be made off this branch
> while trunk receives more exciting developments.
>
>
> 0.6.3  2009-08-02  "Our last, best hope for peace"
>
>        * Fixed an assertion when a job's main process is terminated
>          while in the stopping state.  (Bug: #406408)

Awesome -- that fixes a long outstanding bug that we've seen with
0.5.0 -- thanks Scott!
-Garrett
