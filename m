Return-Path: <linux-kernel-owner+w=401wt.eu-S1754833AbZJZXsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833AbZJZXsT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 19:48:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754722AbZJZXsS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 19:48:18 -0400
Received: from mail-iw0-f180.google.com ([209.85.223.180]:48109 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754727AbZJZXsR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 19:48:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=lGWwxsadSNTKWHNSGjUwn0aJKA5TwF4x6sDL/wQP0gelfwI1K2lwr6NLrF1AQu2+Iu
         mIF4u6bahlXOh7z03cnhl3TPPKb/7CnYXjM13316sIwy8kGgFBTEk2oxl1qrg/zAx51S
         KddvzUD/mfe3fwZDESKzX3ghZ6SBnq21LwV6o=
MIME-Version: 1.0
In-Reply-To: <vX3ILojF2dJ.A.H8F.Yef5KB@chimera>
References: <G2WU8XrUVpF.A.lxF.Ref5KB@chimera>
	 <vX3ILojF2dJ.A.H8F.Yef5KB@chimera>
Date: Mon, 26 Oct 2009 17:48:21 -0600
Message-ID: <51f3faa70910261648h242a9a2dp42cdf554a9eb1342@mail.gmail.com>
Subject: Re: [Bug #14474] restorecond going crazy on 2.6.31.4 - inotify 
	regression?
From: Robert Hancock <hancockrwd@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 26, 2009 at 1:32 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.30 and 2.6.31.
>
> The following bug entry is on the current list of known regressions
> introduced between 2.6.30 and 2.6.31.  Please verify if it still should
> be listed and let me know (either way).
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=14474
> Subject         : restorecond going crazy on 2.6.31.4 - inotify regression?
> Submitter       : Robert Hancock <hancockrwd@gmail.com>
> Date            : 2009-10-16 0:03 (11 days old)
> References      : http://marc.info/?l=linux-kernel&m=125565159520489&w=4

This is definitely reproducible on 2.6.31.4 on CentOS 5.4, I'll likely
try 2.6.31.5 shortly, but it doesn't seem like any of the 2.6.31.5
patches touch inotify..
