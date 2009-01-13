Return-Path: <linux-kernel-owner+w=401wt.eu-S1756440AbZAMEoz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756440AbZAMEoz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 23:44:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752329AbZAMEon
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 23:44:43 -0500
Received: from wa-out-1112.google.com ([209.85.146.177]:59982 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752042AbZAMEom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 23:44:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=NNiYjtO3qvTyGQwKIEj1X78HgoD+tdfX+66zz585mnUOdJETzID2N0NzRUSkszI/w8
         9iuT5X+oJuzSEbJw7r3TtA2joQQDE2hZGs7vnQx5BwCTul7WMDoBCmRxaNfy7lCg0FMe
         dHXLfG85keemCCXxEbFbfPlkq+CiXxyor+3Fc=
Message-ID: <b6a2187b0901122044v1828eeb3lbe1a57367b4862a1@mail.gmail.com>
Date: Tue, 13 Jan 2009 12:44:41 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Regression 2.6.28-git: suspend/resume failure. git bisected to usb suspend/resume patch
Cc: "Christian Borntraeger" <borntraeger@de.ibm.com>,
       "Alan Stern" <stern@rowland.harvard.edu>,
       lkml <linux-kernel@vger.kernel.org>,
       "Greg Kroah-Hartman" <gregkh@suse.de>, linux-usb@vger.kernel.org,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <200901121825.20943.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200901111348.46216.borntraeger@de.ibm.com>
	 <200901120103.53390.rjw@sisk.pl> <200901121341.51674.rjw@sisk.pl>
	 <200901121825.20943.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2009 at 1:25 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> Please see if reverting commit 7503bfbae89eba07b46441a5d1594647f6b8ab7d
> (cpumask: use work_on_cpu in acpi-cpufreq.c for drv_read and drv_write) in
> addition to a0d4922da2e4ccb0973095d8d29f36f6b1b5f703 helps.

I can confirm that with these two commits reverted, my X61 can resume from STD.

> Also, please check if the appended patch fixes the issue with
> a0d4922da2e4ccb0973095d8d29f36f6b1b5f703 .

This patch does not apply cleanly to the latest git pull.

Thanks,
Jeff.
