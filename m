Return-Path: <linux-kernel-owner+w=401wt.eu-S1756628AbYD1EnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756628AbYD1EnT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 00:43:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751177AbYD1EnH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 00:43:07 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:20047 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054AbYD1EnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 00:43:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=s/3/2AuodluVicanC0/wA+C6v+i0wO5SzbwXS6RLiuX8hFSvpF5jYz1RmU9JUYYFG945lStX8FkzE5GQNstpKSLublLkQnaE8irnAd1yYlihl0qYskUQ32hBGJJow/+PSwCE1EX5qxYFQTR1lSvmxGV3bJuC7zgOms1le9OPX0M=
Message-ID: <a36005b50804272143g68dc5f3ax848e9548a3d14ed7@mail.gmail.com>
Date: Sun, 27 Apr 2008 21:43:05 -0700
From: "Ulrich Drepper" <drepper@gmail.com>
To: "Soeren Sandmann" <sandmann@daimi.au.dk>
Subject: Re: stat benchmark
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <ye8wsmnezq9.fsf@camel05.daimi.au.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <ye8wsmnezq9.fsf@camel05.daimi.au.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2008 at 1:59 PM, Soeren Sandmann <sandmann@daimi.au.dk> wrote:
>  So I am looking for ways to improve this.

Aside from what has already been proposed there is also the
readdirplus() route.  Unfortunately the people behind this and related
proposals vanished after the last discussions.  I was  hoping they
come back with a revised proposal but perhaps not.  Maybe it's time to
pick up the ball myself.

As a reminder, readdirplus() is an extended readdir() which also
returns (a subset of) the stat information for the file at the same
time.  The subset part is needed to account for the different
information contained in the inodes.  For most applications the subset
should be sufficient and therefore all that's needed is a single
iteration over the directory.
