Return-Path: <linux-kernel-owner+w=401wt.eu-S1756710AbYCYPQA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756710AbYCYPQA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 11:16:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755035AbYCYPPw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 11:15:52 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:1327 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755196AbYCYPPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 11:15:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=G08FWIngb/YebEgaoEzMp7QbtVQydMPoaikpkMTHr6aA9eF+KlJOOzLwReTO0kMiDN0jd7rknF7aXq7DM6kgqZB6IYmUgW5GnGLUfBKbFkXeZuIKqyW+mFCzQR0WdbZBbRVlMY8rqbXU2HRymRV9RvhhS7iUIiMhgG+udJNOvMw=
Message-ID: <e2e108260803250815n68838589h90f6129062c8f665@mail.gmail.com>
Date: Tue, 25 Mar 2008 16:15:49 +0100
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Kernel compilation: make halts with error message "*** target pattern contains no `%'"
In-Reply-To: <e2e108260803250115j4047b242t85c4d719501482bf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <e2e108260803250115j4047b242t85c4d719501482bf@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 25, 2008 at 9:15 AM, Bart Van Assche
<bart.vanassche@gmail.com> wrote:
>  When I try to compile the latest git tree

Found the cause: apparently this is what happens when the path
containing the kernel source tree contains a colon. Renaming the
kernel source tree directory solved this issue.

Bart.
