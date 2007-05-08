Return-Path: <linux-kernel-owner+w=401wt.eu-S1755308AbXEHFyP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755308AbXEHFyP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 01:54:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755296AbXEHFyK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 01:54:10 -0400
Received: from nz-out-0506.google.com ([64.233.162.236]:37569 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755271AbXEHFyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 01:54:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=fBPk8JT1h0tu7MlmrLi9jbBt8tb1pWahKuyirlNYb2754zDL+a+scphi/V//Cy2dG7ywPy8fKoraTeltqwZvEC0NzsU6Qi7UUb0wkCDuU0SmiQH0E+osVZl/5Bi8oCYRtL1WQYI1iJTumPLhobUirE6Rrf0rCA0D3H0I3gUcTOY=
Message-ID: <787b0d920705072253vd9eb7c4o893412d28706c9a6@mail.gmail.com>
Date: Tue, 8 May 2007 01:53:38 -0400
From: "Albert Cahalan" <acahalan@gmail.com>
To: joern@lazybastard.org, akpm@osdl.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, shaggy@linux.vnet.ibm.com, dgc@sgi.com
Subject: Re: [PATCH 0/2] LogFS take two
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

joern@lazybastard.org, akpm@osdl.org,
linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
shaggy@linux.vnet.ibm.com, dgc@sgi.com

Re: [PATCH 0/2] LogFS take two

You seem to be missing the immutable bit. This is really useful
for dealing with buggy or badly-designed things running as root.
I've used to to protect /dev/null from becoming a normal file
filled with junk, and to protect /etc/resolv.conf from "helpful"
network management daemons that don't know my DNS servers.

Anything else missing?

BTW, BSD offers an unprivileged immutable bit as well. I'm sure
it's useful for the apps that trash their own config files.
Actually, this bit alone would do fine, and we could really use
a way to protect writable device files from deletion or permission
bit changes.
