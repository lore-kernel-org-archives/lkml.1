Return-Path: <linux-kernel-owner+w=401wt.eu-S1751545AbZHZPL2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751545AbZHZPL2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 11:11:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751513AbZHZPL1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 11:11:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12162 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751501AbZHZPL0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 11:11:26 -0400
Subject: Re: v2.6.31-rc6 inotify not reporting deleted files
From: Eric Paris <eparis@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <m1skffj64t.fsf@fess.ebiederm.org>
References: <m1skffj64t.fsf@fess.ebiederm.org>
Content-Type: text/plain
Date: Wed, 26 Aug 2009 11:11:23 -0400
Message-Id: <1251299483.2308.32.camel@dhcp231-106.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-08-26 at 02:06 -0700, Eric W. Biederman wrote:
> I don't have a small test case yet, but I have an application that
> uses inotify and watches a file and takes action when that file has been
> deleted.  Running that application on 2.6.31-rc6 the application is
> no longer seeing the file being deleted.

Are you dealing with hard linked files?

-Eric

