Return-Path: <linux-kernel-owner+w=401wt.eu-S1753263AbZGaVMl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263AbZGaVMl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 17:12:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753208AbZGaVMl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 17:12:41 -0400
Received: from mx2.redhat.com ([66.187.237.31]:43939 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753108AbZGaVMk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 17:12:40 -0400
Date: Fri, 31 Jul 2009 17:11:04 -0400
From: Jeff Layton <jlayton@redhat.com>
To: Shirish Pargaonkar <shirishpargaonkar@gmail.com>
Cc: linux-cifs-client@lists.samba.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [linux-cifs-client] [PATCH] cifs: reinstate original behavior 
 when uid=/gid= options are specified
Message-ID: <20090731171104.33dbc30c@tlielax.poochiereds.net>
In-Reply-To: <4a4634330907311226g409e4098s83059caf8db4f03b@mail.gmail.com>
References: <1249037742-7862-1-git-send-email-jlayton@redhat.com>
	<4a4634330907311226g409e4098s83059caf8db4f03b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Jul 2009 14:26:15 -0500
Shirish Pargaonkar <shirishpargaonkar@gmail.com> wrote:

> Should override_uid  and override_gid be initialized to 1 so that if
> uid and/or gid
> are specified and none of the options, either forceuid/gid and or
> noforceuid/gid are
> specified, the vol-> override defaults to 1 (i.e. forceuid/gid)?
> 

No, I'm using -1 as an indicator of "uninitialized". It's still
considered "true" when cast to a bool (which is what vol->override_*
actually are). That's how I can tell if someone specified forceuid with
no uid= option.
-- 
Jeff Layton <jlayton@redhat.com>
