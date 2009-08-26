Return-Path: <linux-kernel-owner+w=401wt.eu-S1753281AbZHZUMN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281AbZHZUMN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 16:12:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753163AbZHZUMN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 16:12:13 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:41948 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703AbZHZUMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 16:12:12 -0400
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: v2.6.31-rc6 inotify not reporting deleted files
References: <m1skffj64t.fsf@fess.ebiederm.org>
	<1251299483.2308.32.camel@dhcp231-106.rdu.redhat.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 26 Aug 2009 13:12:08 -0700
In-Reply-To: <1251299483.2308.32.camel@dhcp231-106.rdu.redhat.com> (Eric Paris's message of "Wed\, 26 Aug 2009 11\:11\:23 -0400")
Message-ID: <m1eiqy5o87.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: eparis@redhat.com, rjw@sisk.pl, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Paris <eparis@redhat.com> writes:

> On Wed, 2009-08-26 at 02:06 -0700, Eric W. Biederman wrote:
>> I don't have a small test case yet, but I have an application that
>> uses inotify and watches a file and takes action when that file has been
>> deleted.  Running that application on 2.6.31-rc6 the application is
>> no longer seeing the file being deleted.
>
> Are you dealing with hard linked files?

I shouldn't be.  When I skimmed through everything last night it
looked like add a watch for create/delete/modify.  Wait.

File created (see it) file deleted (miss it).

I will go verify I can cook up a reproducer, on my box where it
has been failing consistently.

Eric

