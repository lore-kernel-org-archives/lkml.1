Return-Path: <linux-kernel-owner+w=401wt.eu-S932349AbYDCRRK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932349AbYDCRRK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 13:17:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762224AbYDCRPO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 13:15:14 -0400
Received: from rn-out-0910.google.com ([64.233.170.187]:57506 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762215AbYDCRPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 13:15:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=sGJQuhNS9oX8RITPv3/Hhqg/qabmpWfcn7umZKjw0Iw/lBjsWFpVPpo+IT46SqNfjWg/y6SONRgslg/lfaWufAom9Rx36UCEQc9XcMl4yni9e0iYyjEHfb+qN/YuG0afSoqV87MkVInhFuCRDM5LaTDn6+C1Y/rqvaia1FV4l4k=
Message-ID: <b6c5339f0804031015u2b2dcc6cyd225cd41e45ddd3e@mail.gmail.com>
Date: Thu, 3 Apr 2008 13:15:10 -0400
From: "Bob Copeland" <me@bobcopeland.com>
To: "David Howells" <dhowells@redhat.com>
Subject: Re: [PATCH] AFS: The AFS RPC op CBGetCapabilities is actually CBTellMeAboutYourself
Cc: torvalds@osdl.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080402174813.10046.80641.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080402174813.10046.80641.stgit@warthog.procyon.org.uk>
X-Google-Sender-Auth: 4d002f90b5fc0962
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 2, 2008 at 1:48 PM, David Howells <dhowells@redhat.com> wrote:
>  -static const struct afs_call_type afs_SRXCBGetCapabilites = {
>  -       .name           = "CB.GetCapabilities",
>  -       .deliver        = afs_deliver_cb_get_capabilities,
>  +static const struct afs_call_type afs_SRXCBTellMeAboutYourself = {
>  +       .name           = "CB.",
>  +       .deliver        = afs_deliver_cb_tell_me_about_yourself,

Just curious, is .name meant to be that way?

-Bob
