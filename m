Return-Path: <linux-kernel-owner+w=401wt.eu-S1755291AbZKFJE1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755291AbZKFJE1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 04:04:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753018AbZKFJE0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 04:04:26 -0500
Received: from mtagate4.uk.ibm.com ([195.212.29.137]:57558 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530AbZKFJEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 04:04:22 -0500
From: Christian Borntraeger <borntraeger@de.ibm.com>
Organization: IBM
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 01/11] sysctl: Separate the binary sysctl logic into it's own file.
Date: Fri, 6 Nov 2009 10:04:00 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.32-rc6-self-00026-g91d3f9b; KDE/4.3.2; i686; ; )
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
References: <m1tyx8trik.fsf@fess.ebiederm.org> <1257468114-6823-1-git-send-email-ebiederm@xmission.com>
In-Reply-To: <1257468114-6823-1-git-send-email-ebiederm@xmission.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200911061004.01007.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag 06 November 2009 01:41:44 schrieb Eric W. Biederman:
> From: Eric W. Biederman <ebiederm@xmission.com>
> 
> In preparation for more invasive cleanups separate the core
> binary sysctl logic into it's own file.
> 
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>

Hmm, with your patches on Linus git I get the following on s390:

kernel/sysctl_binary.c: In function 'SYSC_sysctl':
kernel/sysctl_binary.c:126: error: implicit declaration of function 
'lock_kernel'
kernel/sysctl_binary.c:129: error: implicit declaration of function 
'unlock_kernel'

Christian
