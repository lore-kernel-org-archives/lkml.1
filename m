Return-Path: <linux-kernel-owner+w=401wt.eu-S965461AbXCFSIv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965461AbXCFSIv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 13:08:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965516AbXCFSIq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 13:08:46 -0500
Received: from wr-out-0506.google.com ([64.233.184.229]:41799 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965461AbXCFSIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 13:08:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=nBZV9shFfCNptER1/RHVFH4tzwRQxBrQ+yk8FMvoVUoDH+wqBqCsmtW+HPwWlRdNSS8X0PerxbNqHiwsGkLgFiLD8jm/89cK9SAr5VNgZF3lmdA/jBMFQn1tVhgKERpCrDUg0RHshOFsjJgCsPdhGAzgH/cS7baOuI6mvk8XGxU=
Message-ID: <75b66ecd0703061008o3fdd66e5k995e64526cfc45ab@mail.gmail.com>
Date: Tue, 6 Mar 2007 13:08:20 -0500
From: "Lee Revell" <rlrevell@joe-job.com>
To: "Bill Davidsen" <davidsen@tmr.com>
Subject: Re: CONFIG_SYSFS_DEPRECATED and similar issues
Cc: "Linux Kernel mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <45EDA6A3.7010109@tmr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <45EDA6A3.7010109@tmr.com>
X-Google-Sender-Auth: 069ea096405a88d8
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/6/07, Bill Davidsen <davidsen@tmr.com> wrote:
> The other issue is to avoid "trap door" changes, which occur when a
> kernel change requires new user tools, and the user tools will not run
> with older kernels.

CONFIG_SYSFS_DEPRECATED is on by default.  So this upgrading the
kernel does not require userspace changes, unless the user changes the
config, which always has the potential to break userspace.

Users can break their systems by disabling CONFIG_SYSVIPC and
CONFIG_SYSCTL too...

Lee
