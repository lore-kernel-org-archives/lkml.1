Return-Path: <linux-kernel-owner+w=401wt.eu-S1756061AbYIKTIf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756061AbYIKTIf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 15:08:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752674AbYIKTI1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 15:08:27 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51898 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751586AbYIKTI0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 15:08:26 -0400
From: Steve Grubb <sgrubb@redhat.com>
To: linux-audit@redhat.com
Subject: Re: [PATCH 1/2] audit: fix NUL handling in untrusted strings
Date: Thu, 11 Sep 2008 15:08:13 -0400
User-Agent: KMail/1.9.9
Cc: Miloslav =?utf-8?q?Trma=C4=8D?= <mitr@redhat.com>,
       John Dennis <jdennis@redhat.com>, viro@zeniv.linux.org.uk,
       linux-kernel <linux-kernel@vger.kernel.org>
References: <1221085418.2705.19.camel@amilo> <48C955C8.2000602@redhat.com> <1221156612.17533.14.camel@amilo>
In-Reply-To: <1221156612.17533.14.camel@amilo>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200809111508.13658.sgrubb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 11 September 2008 14:10:12 Miloslav Trmač wrote:
> > As a side note I'm concerned there may be places in the user audit
> > code which treat string data as null terminated (at least that is my
> > recollection).
>
> Yes, auditd adds a NUL terminator to the audit record, and then treats
> it as a regular NUL-terminated string; if the audit record contains an
> embedded NUL byte, the rest of the record is discarded by auditd.

In every case where this occurs (kernel or user space), the field values are 
expected to be encoded to prevent it from being discarded.

-Steve
