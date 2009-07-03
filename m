Return-Path: <linux-kernel-owner+w=401wt.eu-S1756005AbZGCAWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756005AbZGCAWS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 20:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753247AbZGCAWD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 20:22:03 -0400
Received: from smtp-out.google.com ([216.239.45.13]:2791 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753009AbZGCAWC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 20:22:02 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=Kw8BIVVL8v86ZINrA/UShBqJP2SfzFG5fzim+Eo/kD+YyQp94TfhJPz3liiouga3z
	QKx66Vedyyi1a+1/7Y4MQ==
MIME-Version: 1.0
In-Reply-To: <20090702165413.f4a21471.akpm@linux-foundation.org>
References: <20090702231814.3969.44308.stgit@menage.mtv.corp.google.com>
	 <20090702232625.3969.54444.stgit@menage.mtv.corp.google.com>
	 <20090702165413.f4a21471.akpm@linux-foundation.org>
Date: Thu, 2 Jul 2009 17:22:02 -0700
Message-ID: <6599ad830907021722x7b012991i1eca056bc72c010c@mail.gmail.com>
Subject: Re: [PATCH 2/2] Ensures correct concurrent opening/reading of 
	pidlists across pid namespaces
From: Paul Menage <menage@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: lizf@cn.fujitzu.com, serue@us.ibm.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       bblum@google.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 2, 2009 at 4:54 PM, Andrew Morton<akpm@linux-foundation.org> wrote:
>
> The way these patches were sent states that you were their primary
> author.  Is that accurate?  If not, they should have had
>
> From: Ben Blum <bblum@google.com>
>
> at the very top of the changelog.

Yes, they're originally by Ben.

Hmm. "git log" in my tree shows:

commit 673496e073c88216b3d2d9fe76eb1163dedb5fa3
Author: Ben Blum <bblum@google.com>
Date:   Thu Jul 2 17:19:24 2009 -0700

    Ensures correct concurrent opening/reading of pidlists across pid namespaces

and "stg edit" shows the first line as:

From: Ben Blum <bblum@google.com>

So I'm not sure how "stg mail" managed to lose that.

Paul
