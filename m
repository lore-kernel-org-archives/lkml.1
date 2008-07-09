Return-Path: <linux-kernel-owner+w=401wt.eu-S1751633AbYGIQHb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751633AbYGIQHb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 12:07:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753454AbYGIQHT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 12:07:19 -0400
Received: from gw.goop.org ([64.81.55.164]:57517 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753316AbYGIQHS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 12:07:18 -0400
Message-ID: <4874E22B.7020808@goop.org>
Date: Wed, 09 Jul 2008 09:07:07 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>
Subject: Re: [patch] xen64: fix !HVC_XEN build dependency
References: <patchbomb.1215554782@localhost> <20080709111219.GA24874@elte.hu> <20080709112133.GA4947@elte.hu>
In-Reply-To: <20080709112133.GA4947@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> another small build problem that -tip testing exposed, with this config:
>
>   http://redhat.com/~mingo/misc/config-Wed_Jul__9_13_02_55_CEST_2008.bad
>
> find the fix below.
>   

Looks good, thanks.  Which reminds me, I should put printf formatting 
checks on those prototypes.

    J
