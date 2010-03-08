Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754481Ab0CHRrU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 12:47:20 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:57910 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136Ab0CHRrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 12:47:14 -0500
Date: Mon, 8 Mar 2010 12:47:07 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       David Howells <dhowells@redhat.com>
Subject: Re: [PATCH,RESEND -mm 2/2] umh && creds: kill subprocess_info->cred
 logic
Message-ID: <20100308174707.GB23634@hmsreliant.think-freely.org>
References: <20100226200357.GB16092@redhat.com>
 <20100226182325.GA31674@redhat.com>
 <20100225181500.GA18008@redhat.com>
 <16951.1267207238@redhat.com>
 <17603.1267209668@redhat.com>
 <20100226200313.GA16092@redhat.com>
 <23363.1267216958@redhat.com>
 <29907.1267226649@redhat.com>
 <20100305225243.GA21790@redhat.com>
 <20100305231054.GB22614@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100305231054.GB22614@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-Spam-Score: -4.1 (----)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 06, 2010 at 12:10:54AM +0100, Oleg Nesterov wrote:
> Now that nobody ever changes subprocess_info->cred we can kill this
> member and related code. ____call_usermodehelper() always runs in the
> context of freshly forked kernel thread, it has the proper ->cred
> copied from its parent kthread, keventd.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> Acked-by: Neil Horman <nhorman@tuxdriver.com>
> ---
> 

Acked-by: Neil Horman <nhorman@tuxdriver.com>

> 
