Return-Path: <linux-kernel-owner+w=401wt.eu-S1751583AbZGYOWu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751583AbZGYOWu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jul 2009 10:22:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751300AbZGYOWt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Jul 2009 10:22:49 -0400
Received: from an-out-0708.google.com ([209.85.132.241]:12365 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076AbZGYOWt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jul 2009 10:22:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=agEISiRW2NUfWHO2lCgZ7KpGGY0mn5N9da5WVldBica+CAv4Mvc4Fw0RDqjnew/YRJ
         Talb9wT9aXXOkvOj4YlVE97rh585QHqifs+Paynz/bg450cenkw4f2OC2fuWJP1MPN/1
         y6LDgqJfgvIc0YQd8gYwT3lbeNAX7BpA46g4A=
MIME-Version: 1.0
In-Reply-To: <1248466429.3567.82.camel@localhost>
References: <1248466429.3567.82.camel@localhost>
Date: Sat, 25 Jul 2009 19:52:48 +0530
Message-ID: <b82a89170907250722o572e741dq372ab11faf58261@mail.gmail.com>
Subject: Re: fanotify - overall design before I start sending patches
From: Niraj kumar <niraj17@gmail.com>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> - subtree notification.
>        Currently to only watch /home and all of it's descendants one must
> either register a directed watch on every directory or use a global
> listener.  The global listener with ignored_mask is not as bad as it
> sounds in my testing, but decent subtree registration and notification
> would be a big win in a lot of people's mind.

Unless it's already covered in some way, I would also be interested
in notification based on "process subtree".  What this means is that
for whatever notification a particular process requests, it's only
interested in events generated  by itself and it's children.
This is useful in doing auditing for file system related access.

-Niraj
