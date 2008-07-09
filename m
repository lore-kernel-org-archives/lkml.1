Return-Path: <linux-kernel-owner+w=401wt.eu-S1755909AbYGIUjo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755909AbYGIUjo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 16:39:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751614AbYGIUjh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 16:39:37 -0400
Received: from gw.goop.org ([64.81.55.164]:53273 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751527AbYGIUjg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 16:39:36 -0400
Message-ID: <487521F7.6070708@goop.org>
Date: Wed, 09 Jul 2008 13:39:19 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       x86@kernel.org, Stephen Tweedie <sct@redhat.com>,
       Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>
Subject: Re: [patch] power, xen64: fix PM_SLEEP build dependencies
References: <patchbomb.1215554782@localhost> <200807092217.53222.rjw@sisk.pl> <48751E34.3060100@goop.org> <200807092233.08930.rjw@sisk.pl>
In-Reply-To: <200807092233.08930.rjw@sisk.pl>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> It does.  And it depends on PM, because HIBERNATION and SUSPEND both depend
> on PM.
>   

OK, so can we change PM_SLEEP to depend on PM && (HIBERNATE || SUSPEND 
|| XEN)?

Or I could add a separate XEN_SAVE_RESTORE config which depends on PM, 
and then we make PM_SLEEP depend on XEN_SAVE_RESTORE.

    J
