Return-Path: <linux-kernel-owner+w=401wt.eu-S1755549AbZBTC7I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755549AbZBTC7I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 21:59:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752851AbZBTC6z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 21:58:55 -0500
Received: from web33506.mail.mud.yahoo.com ([68.142.206.155]:34493 "HELO
	web33506.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752724AbZBTC6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 21:58:54 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type:Message-ID;
  b=o3OplM8NrpCaK0xPwW+6j+L4jan4jIYabucdtlctVZ5THfCD6aLN/KCdPwMYyIBFQuhC3n7MSEw//bePcUb95Skx4828u6JuZQoqxNpQA39XGrVEMDAIOzMWg71kG0qMul5zYRKNBDjpTWhkjk0BR/xf0VnMJgxdSK2gSnOaYn0=;
X-YMail-OSG: xySshyQVM1lixoej_kvM9jszQFAfP4629mZKzlGltjT9.eyVcED1SctoOk0s6YthvlBnVjC7BNYrvfVN7UK1SyOVQCos7ENytwN8gPTkjPvI0G2ia19WSHvkmGe2w0Qwhw2x5vJ26Cb94bPHK3bsBYLOejqwvhPjyOJu6afb.js1H4wUtzOGcoxg3JZc
X-Mailer: YahooMailWebService/0.7.260.1
Date: Thu, 19 Feb 2009 18:52:14 -0800 (PST)
From: Nick Levinson <nick_levinson@yahoo.com>
Subject: suggest allowing comments in current syslog and other logs
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <752772.60434.qm@web33506.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

An unusual series of log events might be readily explainable by root or another user, the best time to do so might be shortly after the time of the events, and the best place to do so might be in the log.

Which other user/s should be allowed to comment directly in the log should be up to root. Nonroot users authorized to comment could be one or more, or all, human users and/or one or more, or all, nonhuman users.

A facility to add a comment to the current position or a prior position in the log should be available, with the comment necessarily date-time stamped and commenter-signed. Prior positions should be any in the current log that is related to an event under the commenter's control, so a nonroot user should not be able to comment in a root-generated event. Or a comment-only entry should be insertable between other events regardless of whose events they were.

The facility should allow root to scroll back in the log, so root can find the appropriate location to comment. A nonroot user should only be able to specify the date and time where the comment should be positioned within the log without being able to read the log; if such a date and time do not exist in the log, the facility should have a root-specified protocol for positioning the comment (e.g., at the beginning of entries for the date) without revealing the location or the use of the protocol to the user.

A root-editable library of template comments should be available, to allow standardizing. A user should be able to maintain their own editable set or template of comments without knowledge of root's template; root should be able to supply an initial template to a user.

A comment by root only should be cleanly removable, to leave no trace of its presence. A comment by any other user should be removable but with a trace of the prior comment necessarily remaining, unless root wants to authorize or perform clean removal.

One admission: I don't have the requisite programming skill, so I'd like to put the idea out for others to take.

What do you think?

Thank you.

-- 
Nick


      
